class JsonTable < Formula
  desc "Transform nested JSON data into tabular data in the shell"
  homepage "https://github.com/micha/json-table"
  url "https://github.com/micha/json-table/archive/refs/tags/4.3.3.tar.gz"
  sha256 "0ab7bb2a705ad3399132060b30b32903762473ff79b5a6e6f52f086e507b0911"
  license "EPL-1.0"
  head "https://github.com/micha/json-table.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "15a5edca4af928b348bdd6eb9c121fec87b790aaf13431e8a0a1753756e3d433"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "2a0e4783bbce7faa941caf2506f8b7d00503c2fd904f4902add6f3e1f29882f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4a11c671903d3c7095c3c9f650e1162afd2f6ccc189c8109162886182d8fd68f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e92d06b25f370ab9811406799e31be9e8f775e88ae9a9417940f4e8a54940c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b90e09e62cd09817662e86c0c9854cd7a6e02b128dec008eeaa24d6c89482f11"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "23e482349f2641ceb4b17f3c05bba8dcbef599a2d3b7eba981dbcce14989e157"
    sha256 cellar: :any_skip_relocation, sonoma:         "2c3cdf120fa2be2558c5e2b2fefb059ca2fbe676522bf59c595f5cecd75b1af4"
    sha256 cellar: :any_skip_relocation, ventura:        "1f355223e0eacbec654b62e3df5525aed0bf8b5fea393e7ccba4bb48d02d8453"
    sha256 cellar: :any_skip_relocation, monterey:       "91ed4ccbdeaf3571036d17d31f6a093e867fc8ec6f1c254c7f79342fcb3ab7cb"
    sha256 cellar: :any_skip_relocation, big_sur:        "56d0c75307c1bfff97077e37070ee7a0532b09614226e5716e7d6a5ad2e2b113"
    sha256 cellar: :any_skip_relocation, catalina:       "61d89ff5426049b2f0fbb237862ec1227cd36c8f00ce81f9a382e8b7d1c2792a"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "c564b0eb11b11de703ca70ad8ab48319c67053309ccfbac1c569184098d27c2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2a8b0576a8a0be8e8bc9bcafcb70ad0fd98197a2f465d4713163fff48ba7696"
  end

  conflicts_with "jot", because: "both install `jt` binaries"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    output = pipe_output("#{bin}/jt x y %", '{"x":{"y":[1,2,3]}}', 0)
    assert_equal "3", output.lines.last.chomp
  end
end
