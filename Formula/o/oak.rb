class Oak < Formula
  desc "Expressive, simple, dynamic programming language"
  homepage "https://oaklang.org/"
  url "https://github.com/thesephist/oak/archive/refs/tags/v0.3.tar.gz"
  sha256 "05bc1c09da8f8d199d169e5a5c5ab2f2923bad6fac624f497f5ea365f378e38a"
  license "MIT"
  head "https://github.com/thesephist/oak.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "815a55a839e22f2903fa5dcd1b0b0c7add13323dba55b9b6cf25e3bf6b89644d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b4add3db56fe8171421dc3fd528ee7d39b54936c03d75b89a42a24c8d8a3a151"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fb8d9531ce0034422a0233fb27c1e77c94910d91f544e18407b8420f67f7f3e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e49abb41ea0758574abb99e97cfae07adeedb324060114815b4c0ead6cbbc674"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c258ac6aacad5e27decb196cb329fc4cb8339950fa110ee1540712872a0ddc4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cbae1b116dcccc5199d3af3e8deb66246c39be3afb5156209b814f83a946599a"
    sha256 cellar: :any_skip_relocation, sonoma:         "14951dfef1335e5db61166951db1cef221b86f5cd10e62ccde2170c9302e4538"
    sha256 cellar: :any_skip_relocation, ventura:        "472a8b58caef8874e3cd7a0a43780a0a3b5fca519815d2646b2fb6488b049e32"
    sha256 cellar: :any_skip_relocation, monterey:       "538fdce9778c8c182d6c369356f02c0d8cd0ba120168eaa204d9ea5d6e423fe6"
    sha256 cellar: :any_skip_relocation, big_sur:        "50e687e3532068bd0948b8760e0bdcf136a6f357600ab1abc5c2089f0d372436"
    sha256 cellar: :any_skip_relocation, catalina:       "c206c1cb5f34b507830290b8e273cf65d2c76f08ce5f014a17fd8653a63cce0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "50a204d94668d846405a53b9c16d42edea86f7448c8961139b3450702c382028"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c902712d736c06e8f065b2046ad172b66c7ae075a2ccdd3c19c859616577fe50"
  end

  depends_on "go" => :build

  conflicts_with "oakc", because: "both install `oak` binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_equal "Hello, World!\n14\n", shell_output("#{bin}/oak eval \"std.println('Hello, World!')\"")
  end
end
