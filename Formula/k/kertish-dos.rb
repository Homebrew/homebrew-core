class KertishDos < Formula
  desc "Kertish Object Storage and Cluster Administration CLI"
  homepage "https://github.com/freakmaxi/kertish-dos"
  url "https://github.com/freakmaxi/kertish-dos/archive/refs/tags/v22.2.0147.tar.gz"
  version "22.2.0147-532592"
  sha256 "fe76b525762a3240e8c4bc8e6d7caedebf466aec81c1a22f8014d6881c2bdaf6"
  license "GPL-3.0-only"
  head "https://github.com/freakmaxi/kertish-dos.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bce3b8645b27f84f8c8452740dfd4494c747fbee848d8d667148fd1e0cc19db8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b3abc8c569185063a1ba3d2e6d634c446cad8ee07d4ae36c31221aa875dd6bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db21c167e067540fd373e1c963f5ab5b55ed94e642541b457a5806ceb7546db5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "66e15349b37cc6586d55d102d5941565aa0db46e4a5c1cbaa87f5c45b946180d"
    sha256 cellar: :any_skip_relocation, sonoma:        "58bf87f97fb1e1399d1a09a0de3d9db3ba783c821343ef8de762ba835417b6fe"
    sha256 cellar: :any_skip_relocation, ventura:       "bfd2942609310c775b5ae27df2a982300f03603edd8745856c3ab0c2d544b3eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "35615629ee3146399af7190ed267eacbad3123c2b0515a91c35b518d41c9dea7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbca4d722bae4b3f940401a080bdf08f664411b93c161dba75f06686c52e2c94"
  end

  depends_on "go" => :build

  def install
    cd "fs-tool" do
      system "go", "build", *std_go_args(output: bin/"krtfs", ldflags: "-X main.version=#{version}")
    end
    cd "admin-tool" do
      system "go", "build", *std_go_args(output: bin/"krtadm", ldflags: "-X main.version=#{version}")
    end
  end

  test do
    port = free_port
    assert_match("failed.\nlocalhost:#{port}: head node is not reachable",
      shell_output("#{bin}/krtfs -t localhost:#{port} ls"))
    assert_match("localhost:#{port}: manager node is not reachable",
      shell_output("#{bin}/krtadm -t localhost:#{port} -get-clusters", 70))
  end
end
