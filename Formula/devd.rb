class Devd < Formula
  desc "Local webserver for developers"
  homepage "https://github.com/cortesi/devd"
  license "MIT"
  head "https://github.com/cortesi/devd.git", branch: "master"

  stable do
    url "https://github.com/cortesi/devd/archive/v0.9.tar.gz"
    sha256 "5aee062c49ffba1e596713c0c32d88340360744f57619f95809d01c59bff071f"

    # Get go.mod and go.sum from commit after v0.9 release.
    # Ref: https://github.com/cortesi/devd/commit/4ab3fc9061542fd35b5544627354e5755fa74c1c
    # TODO: Remove in the next release.
    resource "go.mod" do
      url "https://raw.githubusercontent.com/cortesi/devd/4ab3fc9061542fd35b5544627354e5755fa74c1c/go.mod"
      sha256 "483b4294205cf2dea2d68b8f99aefcf95aadac229abc2a299f4d1303f645e6b0"
    end
    resource "go.sum" do
      url "https://raw.githubusercontent.com/cortesi/devd/4ab3fc9061542fd35b5544627354e5755fa74c1c/go.sum"
      sha256 "3fb5d8aa8edfefd635db6de1fda8ca079328b6af62fea704993e06868cfb3199"
    end
  end

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_monterey: "066a8cb9c2a379b7b4c77476dcad100ef1b50ca211717460de1b23727f540e51"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1adc7ff42fb9063f2724578755a548a4b52244269c03ffef599bad06da2641d0"
    sha256 cellar: :any_skip_relocation, monterey:       "c5a739aeae1644c64f5dde53190c6050ecf28ff7ae06867e604679391684c5df"
    sha256 cellar: :any_skip_relocation, big_sur:        "3a80a457e6b056c0b00d9b1dbbce26c18c36285e4296100d1196875988ee6b7c"
    sha256 cellar: :any_skip_relocation, catalina:       "5a1dceea4de81075bab6e0617b38c39f715423c4e8e0d17f75f65d7e15cf7dee"
    sha256 cellar: :any_skip_relocation, mojave:         "33c299776d5aa228d68b36d9d51af12b04d5e65a194b907900bd117882a45f27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19d3cb4f63a05ccd30e3e819940ce9f7f50732d4478a04a65cb6d54d31852a7c"
  end

  depends_on "go" => :build

  def install
    if build.stable?
      buildpath.install resource("go.mod")
      buildpath.install resource("go.sum")

      # Update x/sys to support go 1.17.
      # PR ref: https://github.com/cortesi/devd/pull/117
      inreplace "go.mod", "golang.org/x/sys v0.0.0-20181221143128-b4a75ba826a6",
                          "golang.org/x/sys v0.0.0-20210819135213-f52c844e1c1c"
      (buildpath/"go.sum").append_lines <<~EOS
        golang.org/x/sys v0.0.0-20210819135213-f52c844e1c1c h1:Lyn7+CqXIiC+LOR9aHD6jDK+hPcmAuCfuXztd1v4w1Q=
        golang.org/x/sys v0.0.0-20210819135213-f52c844e1c1c/go.mod h1:oPkhp1MJrh7nUepCBck5+mAzfO9JrbApNNgaTdGDITg=
      EOS
    end

    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/devd"
  end

  test do
    (testpath/"www/example.txt").write <<~EOS
      Hello World!
    EOS

    port = free_port
    fork { exec "#{bin}/devd", "--port=#{port}", "#{testpath}/www" }
    sleep 2

    output = shell_output("curl --silent 127.0.0.1:#{port}/example.txt")
    assert_equal "Hello World!\n", output
  end
end
