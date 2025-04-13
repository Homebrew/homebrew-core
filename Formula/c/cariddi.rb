class Cariddi < Formula
  desc "Scan for endpoints, secrets, API keys, file extensions, tokens and more"
  homepage "https://github.com/edoardottt/cariddi"
  url "https://github.com/edoardottt/cariddi/archive/refs/tags/v1.3.6.tar.gz"
  sha256 "9f903443bcc78c9c4133a51c154a7f2bcec3968792fe66d5e4c19803ef5b6f06"
  license "GPL-3.0-or-later"
  head "https://github.com/edoardottt/cariddi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "894378d05f9d4477e241766e38f750d69c6fcee0655d4ef1528bf8fa838e16ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "894378d05f9d4477e241766e38f750d69c6fcee0655d4ef1528bf8fa838e16ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "894378d05f9d4477e241766e38f750d69c6fcee0655d4ef1528bf8fa838e16ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f9fbe00baf1a022dd67b426a757c8e4abbb8e3ab247728b4f28a1de13c0638a"
    sha256 cellar: :any_skip_relocation, ventura:       "4f9fbe00baf1a022dd67b426a757c8e4abbb8e3ab247728b4f28a1de13c0638a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94101fae87842104aa9e9eabcfe8193da6b68578ce4dfe8f490b99d20986eb49"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cariddi"
  end

  test do
    output = pipe_output(bin/"cariddi", "http://testphp.vulnweb.com")
    assert_match "http://testphp.vulnweb.com/login.php", output

    assert_match version.to_s, shell_output("#{bin}/cariddi -version 2>&1")
  end
end
