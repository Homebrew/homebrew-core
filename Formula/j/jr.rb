class Jr < Formula
  desc "CLI program that helps you to create quality random data for your applications"
  homepage "https://jrnd.io/"
  url "https://github.com/ugol/jr/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "fa60365c0ca7b5ff70ef357ff362c7da069aa07a5daa8303f0af04ae75d04f67"
  license "MIT"
  head "https://github.com/ugol/jr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bb26ad57ef2455ff9e7453c3375592a5ebadffa199e9dfa7f9354a59566a46b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b0b3ccbca4be464ee548c37717ea4afc431912021d94ebc9b9f17646fe509c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9993a1b688e50cda4d1240ba5aa16948aab8da1bf74b9ab35be1aa52b367dff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "868667b63f0950733c93d580213595268f8b71d7ed28234b5e4da7640ecb079d"
    sha256 cellar: :any_skip_relocation, sonoma:         "2bacdd3c37a42321e68832fff08c8be3a2169410ecb1a6068e0de2ee4f717456"
    sha256 cellar: :any_skip_relocation, ventura:        "5c508bac1e29ddba1a81cd73614a2e0becc38c57793ea30da8e64deef5ff939c"
    sha256 cellar: :any_skip_relocation, monterey:       "c3860cefd59332623af358c33c7df7bc046d05193ed21a591d76b65d21a5f9f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "e5443a9872d74d90c1e01247db4b8affe71400d104e9eeef49fb08a9ff823784"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c3a34221d741ad3c9561b520056343f5718a8e511af55260cc7444277ffaa3b"
  end

  depends_on "go" => :build

  def install
    system "make", "all"
    libexec.install Dir["build/*"]
    pkgetc.install "config/jrconfig.json"
    pkgetc.install "templates"
    (bin/"jr").write_env_script libexec/"jr", JR_HOME: pkgetc
  end

  test do
    assert_match "net_device", shell_output("#{bin}/jr template list").strip
  end
end
