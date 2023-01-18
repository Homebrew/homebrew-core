class GoPms < Formula
  desc "CLI of Postgres Migration System"
  homepage "https://github.com/Moranilt/pms"
  url "https://github.com/Moranilt/pms/archive/refs/tags/v0.2.1.tar.gz"

  sha256 "88028e66924494a3aecf0a14bfa6f88aa6719cac92714979621c3e31a67f87c5"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd"
  end

  test do
    assert_match "error: 'db' flag required", shell_output("#{bin}/go-pms").strip
    assert_match "error: provide 'up', 'down' or 'version' flag", shell_output("#{bin}/go-pms -db test").strip
  end
end
