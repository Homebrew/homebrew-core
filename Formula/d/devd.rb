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
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "13847da393a2fc68810f987451c78f751fd9a3ea4fc2e07a00b01464f3eed02c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "82d937b6bcf0f37755df12694e934a8032ce155fc2895ec227f4887b2662d9c2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "47f06f9c6157c81eaf52040448e5f131a6a660f96e78186146ab469345e6ea96"
    sha256 cellar: :any_skip_relocation, ventura:        "c3a45de493d66241a712df0ec91b66bbb110a221e9e5b4d0216050dea7cc7e9e"
    sha256 cellar: :any_skip_relocation, monterey:       "e815c896205297337741c856016809aa6603547c4a4302acb0ad307f3c91f10c"
    sha256 cellar: :any_skip_relocation, big_sur:        "446557dc47076e2e0f4d93d6e33ecdac80721f4da9c391af29154509c425dd57"
    sha256 cellar: :any_skip_relocation, catalina:       "0bfc6ccb8402282c4c3b3bf375cc3be882deba31f35a627801f3009456bf62f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c82a9adb431d63c5ac65d04c6f27592e6fe23a3ffa0e5a118fd34a113d32af4"
  end

  # Current release is from 2019-01-20 and needs deprecated `dep` to build.
  # We backported upstream support for Go modules, but have not received
  # a response on request for a new release since 2021-01-21.
  # Issue ref: https://github.com/cortesi/devd/issues/115
  deprecate! date: "2022-09-21", because: :unmaintained

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
