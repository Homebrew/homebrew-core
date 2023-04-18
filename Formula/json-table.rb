class JsonTable < Formula
  desc "Transform nested JSON data into tabular data in the shell"
  homepage "https://github.com/micha/json-table"
  url "https://github.com/micha/json-table/archive/4.3.3.tar.gz"
  sha256 "0ab7bb2a705ad3399132060b30b32903762473ff79b5a6e6f52f086e507b0911"
  license "EPL-1.0"
  head "https://github.com/micha/json-table.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e92d06b25f370ab9811406799e31be9e8f775e88ae9a9417940f4e8a54940c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b90e09e62cd09817662e86c0c9854cd7a6e02b128dec008eeaa24d6c89482f11"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "23e482349f2641ceb4b17f3c05bba8dcbef599a2d3b7eba981dbcce14989e157"
    sha256 cellar: :any_skip_relocation, ventura:        "1f355223e0eacbec654b62e3df5525aed0bf8b5fea393e7ccba4bb48d02d8453"
    sha256 cellar: :any_skip_relocation, monterey:       "91ed4ccbdeaf3571036d17d31f6a093e867fc8ec6f1c254c7f79342fcb3ab7cb"
    sha256 cellar: :any_skip_relocation, big_sur:        "56d0c75307c1bfff97077e37070ee7a0532b09614226e5716e7d6a5ad2e2b113"
    sha256 cellar: :any_skip_relocation, catalina:       "61d89ff5426049b2f0fbb237862ec1227cd36c8f00ce81f9a382e8b7d1c2792a"
    sha256 cellar: :any_skip_relocation, mojave:         "49f7c1f8e757456f63d5e8b9cb7ef0f2b1cdb22303b2ae799595305cb7e65c5b"
    sha256 cellar: :any_skip_relocation, high_sierra:    "2afef9b965070bcde986759dbd03cfd8fe3e77aec5a12158fb4aa189626ab977"
    sha256 cellar: :any_skip_relocation, sierra:         "e5ed8ece1e10ede4417f347703f1e62bb417c65a11f6cac5f10915d44359eb5b"
    sha256 cellar: :any_skip_relocation, el_capitan:     "3240813838be9e797fd443e5f51d6bb53fc56a8d958dd361cbc865de003619bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2a8b0576a8a0be8e8bc9bcafcb70ad0fd98197a2f465d4713163fff48ba7696"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    output = pipe_output("#{bin}/jt x y %", '{"x":{"y":[1,2,3]}}', 0)
    assert_equal "3", output.lines.last.chomp
  end
end
