class Aliyunpan < Formula
  desc "Command-line client tool for Alibaba aDrive disk"
  homepage "https://github.com/tickstep/aliyunpan"
  url "https://github.com/tickstep/aliyunpan/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "b68726a13bcaba6353b1c89950695a71397ad2c722aa25750b82583701121fdd"
  license "Apache-2.0"
  head "https://github.com/tickstep/aliyunpan.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e8dee6a5bbe550e896834d527001a9430b616c34f706b8ad976c97cd8b0746b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8dee6a5bbe550e896834d527001a9430b616c34f706b8ad976c97cd8b0746b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8dee6a5bbe550e896834d527001a9430b616c34f706b8ad976c97cd8b0746b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "16cdf7a3e4417b11b7c0e179f323bb20b0a48b340ff60d9b6ee729b7cea6ce33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9190a0940d7edf455b803f0417997a771743dc95b8fd69783246ee441496cb1c"
    sha256 cellar: :any,                 x86_64_linux:  "c930d31bb71e9fc30bd76b31ab95328e34b0bd63ea84e3ce1df8bb807ec1b2e5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"aliyunpan", "run", "touch", "output.txt"
    assert_path_exists testpath/"output.txt"
  end
end
