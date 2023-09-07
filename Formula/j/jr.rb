class Jr < Formula
  desc "CLI program that helps you to create quality random data for your applications"
  homepage "https://jrnd.io/"
  url "https://github.com/ugol/jr/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "fa60365c0ca7b5ff70ef357ff362c7da069aa07a5daa8303f0af04ae75d04f67"
  license "MIT"
  head "https://github.com/ugol/jr.git", branch: "main"

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
