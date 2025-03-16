class Nesfab < Formula
  desc "Programming language that targets the Nintendo Entertainment System"
  homepage "https://pubby.games/nesfab.html"
  url "https://github.com/pubby/nesfab/archive/refs/tags/v1.8.tar.gz"
  sha256 "e260370dd172c63329d2c432fb717678959631153e15c7013ca3a3591b302014"
  license "GPL-3.0-only"

  depends_on "boost"
  # The libc++ on Ventura is missing C++20 features this codebase depends on.
  depends_on macos: :sonoma

  fails_with :clang do
    build 1599
    cause "Missing std::lexicographical_compare_three_way"
  end

  def install
    # Native in-repo build puts the Git object ID into the binary for the --version
    # string. It's not necessary functionality, but the string looks weird if the
    # SHA is totally empty, so we'll at least say where it's from.
    args = ["GIT_COMMIT=homebrew"]

    args << "CXX=#{ENV.cxx}" if OS.mac?
    args << "ARCH=" if Hardware::CPU.arm?

    system "make", *args, "release"
    bin.install "nesfab" => "nesfab-release"

    system "make", "clean"
    # `debug` flavor isn't about the NESFab binary, it's about the NESFab compiler
    # inserting runtime checks in the generated code. The typical development
    # workflow is to use the `debug` flavor most of the time, but ship the output
    # of the `release` flavor. Hence, the binary called "nesfab" is debug and
    # there's a separately named binary for generating release games.
    system "make", *args, "debug"
    bin.install "nesfab"
  end

  test do
    (testpath/"example.fab").write <<~NESFAB
      vars /sound
          UU pitch = 1000

      fn play_sound()
          {$4015}(%100)
          {$4008}($FF)
          {$400A}(pitch.a)
          {$400B}(pitch.b & %111)

      mode main()
        {$2000}(%10000000)
        while true
            pitch *= 1.01
            play_sound()
            nmi
    NESFAB
    system bin/"nesfab", "example.fab", "--output", "game.nes"
    assert_path_exists testpath/"game.nes"
  end
end
