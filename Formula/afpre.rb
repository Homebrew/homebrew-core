class Afpre < Formula
  desc "CLI for the AWS Federation Proxy"
  homepage "https://github.com/leflamm/afpre"
  url "https://github.com/leflamm/afpre/archive/0.9.9.tar.gz"
  sha256 "793ae1e8bb8c98ba4d6e3b21aa150a3dabefbd9ebd69a935495dd58c0305319c"

  head "https://github.com/leflamm/afpre.git"

  depends_on "jq"

  def install
    bin.install "afpre"
    chmod 0555, bin/"afpre"
  end

  test do
    system "true"
  end
end
