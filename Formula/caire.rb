class Caire < Formula
  desc "Content aware image resize tool"
  homepage "https://github.com/esimov/caire"
  url "https://github.com/esimov/caire/archive/v1.4.6.tar.gz"
  sha256 "91af988656924387c1c2c7ccf0c263c2df2843bbfca58d28c5ea239cee4861af"
  license "MIT"
  head "https://github.com/esimov/caire.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "510be9ef3971dd6594e3d662a8a4a8f97fe5d587a902cabb803425a61b531b8f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d59ce1a8791d14ee71f54abe8b0cadfe19ba512b90b13f2f8f7625b0e1a5ade"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6dc0a2e1542d2843ebca8f84d72c5cc74db54b6c09a3cf77bf71879156f9812b"
    sha256 cellar: :any_skip_relocation, ventura:        "aab352ffb29304bf5b53fd7f17781e615bb6e2968fcf553dfb6c8b66c1a024e1"
    sha256 cellar: :any_skip_relocation, monterey:       "9201a9019646d54bd87e4b04eb93249e6b423a985fa8562b8c6153f140d69c5a"
    sha256 cellar: :any_skip_relocation, big_sur:        "56c8c4cc534e40b5b9d157f4ab6327fa660d4b86bf4884340b74fb1fdd0f9d20"
    sha256 cellar: :any_skip_relocation, catalina:       "2e2a3e4286f0358b389ad7e991959428bd8afb9fc5c2936aa74d007d6e8497e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c393ce400070a99e19f770ab66b0a3b0c581d7eeb1e91a120979e94c4f97949d"
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
