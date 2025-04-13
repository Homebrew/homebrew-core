class OpenscaCli < Formula
  desc "OpenSCA is a supply-chain security tool for security researchers and developers"
  homepage "https://opensca.xmirror.cn"
  url "https://github.com/XmirrorSecurity/OpenSCA-cli/archive/refs/tags/v3.0.7.tar.gz"
  sha256 "ccf553dbfd5fea4e33dbc35a25d61db3392370f5b9976d1ee2c2763c27076ea1"
  license "Apache-2.0"
  head "https://github.com/XmirrorSecurity/OpenSCA-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5209a8c6a9858c7671fdb89eef3c5e2054e79604d9bbf809c63fcfd59a71feaf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e266e781fad368e3fad32b50ec6cacfd33f9c78f776e512c7262c161a6f5b901"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b19c63574ca16ebfb800f75104ff2a06a7238ac3aba6b60c03be5a007519d193"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ba8e5e130f6803f188669e9faa74a2dd85dffbda04ac5719651bbfb9cbd59ac"
    sha256 cellar: :any_skip_relocation, ventura:       "21248219510663cff235f854091d2814f792960deb166f926cd589f372f70fd8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f354006480e757ef28169c45ffe8d594620e087ec0de50ff86d2917a328a580"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8baaebe279ae6ac1683d6a89af883fc5688b592b4d8f52cd5ff30808e9450d41"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X 'main.version=#{version}'"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    system bin/"opensca-cli", "-path", testpath
    assert_path_exists testpath/"opensca.log"
    assert_match version.to_s, shell_output(bin/"opensca-cli -version")
  end
end
