class Baguette < Formula
  desc "Headless iOS Simulator manager and host-side input injection for iOS 26"
  homepage "https://tddworks.github.io/baguette/"
  url "https://github.com/tddworks/baguette/archive/refs/tags/v0.1.94.tar.gz"
  sha256 "925994e685e39df516abdab1dcac9657d974140c6e01a6acce26e33b5c57f85d"
  license "Apache-2.0"
  head "https://github.com/tddworks/baguette.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe: "902c5cba54e44408d40dbb08ff7faf6a34edef24d50700a5679bcfbf5377fe84"
  end

  depends_on xcode: ["26.0", :build]
  depends_on arch: :arm64
  depends_on macos: :tahoe

  def install
    # replace version like upstreams release process
    inreplace "Sources/Baguette/App/Version.swift",
              "let baguetteVersion = \"0.1.61\"",
              %Q(let baguetteVersion = "#{version}")

    # Upstream commits the iOS-Simulator injection dylibs prebuilt and universal, which
    # `brew audit` rejects, so rebuild them from source for this arch alone.
    # `Injected/build.sh` loops over every `Injected/<Name>/`, so a dylib added upstream
    # needs no change here. It honours `BAGUETTE_INJECTED_ARCHS`, links each slice with
    # `-headerpad_max_install_names` to leave room for the Cellar-path install ID written
    # during relocation, and stages the result where SPM copies it from. Homebrew
    # re-signing over `-adhoc_codesign` is fine: baguette copies each dylib to a
    # content-hashed path before injecting it.
    rm Dir["Sources/Baguette/Resources/*/*.dylib"]
    with_env(BAGUETTE_INJECTED_ARCHS: Hardware::CPU.arch.to_s) do
      system "./Injected/build.sh"
    end

    system "swift", "build", *std_swift_args

    # Binary and its SPM resource bundle must sit side-by-side at runtime —
    # WebRoot resolves the bundle via dladdr from the executable's directory.
    # Install both into libexec and symlink the binary into bin.
    libexec.install ".build/release/Baguette" => "baguette"
    libexec.install ".build/release/Baguette_Baguette.bundle"
    bin.install_symlink libexec/"baguette"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/baguette --version")

    # The top-level help lists the simulator-control subcommands, confirming
    # the binary and its argument parser initialize without a booted device.
    assert_match "Headless iOS simulator control", shell_output("#{bin}/baguette --help")

    # Unknown subcommands are rejected with a usage error (exit code 64),
    # exercising real argument parsing offline with no booted simulator.
    assert_match "Usage: baguette", shell_output("#{bin}/baguette no-such-command 2>&1", 64)

    # The injected dylibs must survive keg relocation as thin, non-empty Mach-O
    # libraries. Asserted rather than assumed: clang exits 0 on an empty source
    # list, so a formula that mis-globs the sources yields loadable 16KB stubs
    # that inject nothing and report no error.
    dylibs = Dir["#{libexec}/Baguette_Baguette.bundle/*/*.dylib"]
    assert_operator dylibs.length, :>=, 3
    dylibs.each do |dylib|
      refute_match "universal binary", shell_output("file #{dylib}")
      assert_match(/^[0-9a-f]+ /, shell_output("nm -gU #{dylib}"))
    end
  end
end
