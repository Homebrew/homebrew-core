class Darkhttpd < Formula
  desc "Small static webserver without CGI"
  homepage "https://unix4lyfe.org/darkhttpd/"
  url "https://github.com/emikulic/darkhttpd/archive/refs/tags/v1.15.tar.gz"
  sha256 "ea48cedafbf43186f4a8d1afc99b33b671adee99519658446022e6f63bd9eda9"
  license "ISC"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b4575d9563bf8f1deb6ac378bfaf6dcb20745bc5dfa5a171443b5347dd2a2675"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c29c9bc9b683abc5c29dce50f4dbc81ba3be1c9d8288a9d2d1bb23776b5df72"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c69a71ac042d86aafae7cf5f99aa0aca1bc131519b38d5c6e76529ca212cac0"
    sha256 cellar: :any_skip_relocation, sonoma:         "5c53c66748d2c2a370ab38bf8b3c25373175ad3690c0cf26a41ff47f08845343"
    sha256 cellar: :any_skip_relocation, ventura:        "198c0763540063196c5b0a374b9e8360ca910cc89b68da86fe9d4d2344b89e04"
    sha256 cellar: :any_skip_relocation, monterey:       "39a30b5c8cd090897260a673c46d743d3399bee24a23fbcb6c365c764ebcb9b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ecd7d4cd140e15d5a5032fbe47862a97c183eace8f1df4e117923ed8ea8171c"
  end

  def install
    system "make"
    bin.install "darkhttpd"
  end

  test do
    system "#{bin}/darkhttpd", "--help"
  end
end
