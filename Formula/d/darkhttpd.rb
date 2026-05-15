class Darkhttpd < Formula
  desc "Small static webserver without CGI"
  homepage "https://unix4lyfe.org/darkhttpd/"
  url "https://github.com/emikulic/darkhttpd/archive/refs/tags/v1.17.tar.gz"
  sha256 "4fee9927e2d8bb0a302f0dd62f9ff1e075748fa9f5162c9481a7a58b41462b56"
  license "ISC"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d789a550bcdedb7039ec2eb15b5c6a57f93d8848fc471ab97caa8ce324fa04e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c69e08e8c2ebf5a9a688b1b8ef04023479a883c4cb59fb37f4d079e552bfcb3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "442e6a89ba63bf57480ce24b9f1b1328df91acfcd2232965ff60649a4f72cf28"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c91049fd08525931a2723036bc87b1bd4e43eac4f35faaef7fdb299be8e509d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7fb32f512690f230d1ef4febeace561eaa4dc0837b40cf5b59a71f0f91da6d6"
    sha256 cellar: :any_skip_relocation, ventura:       "cba66b5df314cfe3df8307c5c35b5aaae430e9019038ee2392c58f2e3bcc3b47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f98b866298dad9e43a231d2414160dec2b5782fc859edc12f766a49a3eaebb11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "576d06ada412f04a6d4d8bea220aeb09a85f108cfe4457a4002d0c849996b44c"
  end

  def install
    system "make"
    bin.install "darkhttpd"
  end

  test do
    system bin/"darkhttpd", "--help"
  end
end
