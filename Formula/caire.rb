class Caire < Formula
  desc "Content aware image resize tool"
  homepage "https://github.com/esimov/caire"
  url "https://github.com/esimov/caire/archive/v1.4.3.tar.gz"
  sha256 "80841c430d3022ef768efe50f8a895239fe8f4d86f3e51a76efc0b5026f13fdc"
  license "MIT"
  head "https://github.com/esimov/caire.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bee65859e250a2a4956ac79d801d153ebb9bba79855af30b044cd46163270b7a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d4131ae8539f485e273560df33d4805f6fe36d8e40a246f6a0493cff1ac857c8"
    sha256 cellar: :any_skip_relocation, monterey:       "fb89fb30bcca34b701351098260051614d177b5688396116f9c64cdde8a2b3cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "392b71adf8059ca52b33e368141453086732d7d9ca887226d2bfaa339ffd8f58"
    sha256 cellar: :any_skip_relocation, catalina:       "98882a53c798df215e9989b351870aa5250334256799a7ed24e8daada3c3b743"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eddfdd672969291471f7690ae96a379d3b0e4fc2bca1911ca441b646cbece01e"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "vulkan-headers" => :build
    depends_on "libxcursor"
    depends_on "libxkbcommon"
    depends_on "mesa"
    depends_on "wayland"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/caire"
  end

  test do
    pid = fork do
      system bin/"caire", "-in", test_fixtures("test.png"), "-out", testpath/"test_out.png",
            "-width=1", "-height=1", "-perc=1"
      assert_predicate testpath/"test_out.png", :exist?
    end

    assert_match version.to_s, shell_output("#{bin}/caire -help 2>&1")
  ensure
    Process.kill("HUP", pid)
  end
end
