class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  license "GPL-3.0-only"
  revision 1
  head "https://github.com/golangci/golangci-lint.git", branch: "master"

  stable do
    url "https://github.com/golangci/golangci-lint.git",
        tag:      "v1.50.1",
        revision: "8926a95fa8e051dca7cc4a9921a5f7f9bebdc8d2"

    # patch for apple diff
    # upstream commit ref, https://github.com/golangci/golangci-lint/commit/58ebedda6341e2f67d4338eb1d8f75b4a54590d1
    # remove in next release
    patch :DATA
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70ac993144ba0e3492009346ad0d743ddcb825269735c9266e52a57c49efd3a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c917c15c6697f8766f6a3a1c37f6f456f3e2dbc1d9e527177ad135988987fb57"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c09d144a856018030132dcc7d0490a78ded921ecbeaeeb97e456bec4da2ac088"
    sha256 cellar: :any_skip_relocation, ventura:        "7fd953f85152eed22c03ef734fe137b0f1ce16bbc7c574befd32f1d18e0ddca1"
    sha256 cellar: :any_skip_relocation, monterey:       "f64fa1c0e95269945e42735e142976770e9b5e15e98ea43f6c2b3650942cdd6b"
    sha256 cellar: :any_skip_relocation, big_sur:        "c7b7076639e6a428f1f67cbac1c2263948c6a3e48618a6c3ec901bffead9fbc7"
    sha256 cellar: :any_skip_relocation, catalina:       "c4642ab2491b3b392e14838b0acf552a28ec446b39dc41fe5ae6a8d3618b834b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60ac582f5c1e1fbf5bf8cb54c653a3a2ce4e3099788ed084cfd67a735511a5b9"
  end

  depends_on "go"

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_short_head(length: 7)}
      -X main.date=#{time.rfc3339}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/golangci-lint"

    generate_completions_from_executable(bin/"golangci-lint", "completion")
  end

  test do
    str_version = shell_output("#{bin}/golangci-lint --version")
    assert_match "golangci-lint has version #{version} built from", str_version

    str_help = shell_output("#{bin}/golangci-lint --help")
    str_default = shell_output("#{bin}/golangci-lint")
    assert_equal str_default, str_help
    assert_match "Usage:", str_help
    assert_match "Available Commands:", str_help

    (testpath/"try.go").write <<~EOS
      package try

      func add(nums ...int) (res int) {
        for _, n := range nums {
          res += n
        }
        return
      }
    EOS

    args = %w[
      --color=never
      --disable-all
      --issues-exit-code=0
      --print-issued-lines=false
      --enable=unused
    ].join(" ")

    ok_test = shell_output("#{bin}/golangci-lint run #{args} #{testpath}/try.go")
    expected_message = "try.go:3:6: func `add` is unused (unused)"
    assert_match expected_message, ok_test
  end
end

__END__
diff --git a/go.mod b/go.mod
index 0050eca9..d945ee54 100644
--- a/go.mod
+++ b/go.mod
@@ -87,7 +87,7 @@ require (
 	github.com/sivchari/containedctx v1.0.2
 	github.com/sivchari/tenv v1.7.0
 	github.com/sonatard/noctx v0.0.1
-	github.com/sourcegraph/go-diff v0.6.1
+	github.com/sourcegraph/go-diff v0.6.2-0.20221031073116-7ef5f68ebea1
 	github.com/spf13/cobra v1.6.0
 	github.com/spf13/pflag v1.0.5
 	github.com/spf13/viper v1.12.0
diff --git a/go.sum b/go.sum
index 4fb2714e..42cf46a3 100644
--- a/go.sum
+++ b/go.sum
@@ -494,6 +494,8 @@ github.com/sonatard/noctx v0.0.1 h1:VC1Qhl6Oxx9vvWo3UDgrGXYCeKCe3Wbw7qAWL6FrmTY=
 github.com/sonatard/noctx v0.0.1/go.mod h1:9D2D/EoULe8Yy2joDHJj7bv3sZoq9AaSb8B4lqBjiZI=
 github.com/sourcegraph/go-diff v0.6.1 h1:hmA1LzxW0n1c3Q4YbrFgg4P99GSnebYa3x8gr0HZqLQ=
 github.com/sourcegraph/go-diff v0.6.1/go.mod h1:iBszgVvyxdc8SFZ7gm69go2KDdt3ag071iBaWPF6cjs=
+github.com/sourcegraph/go-diff v0.6.2-0.20221031073116-7ef5f68ebea1 h1:FEIBISvqa2IsyC4KQQBQ1Ef2QvweGUgEIjCdE3gz+zs=
+github.com/sourcegraph/go-diff v0.6.2-0.20221031073116-7ef5f68ebea1/go.mod h1:iBszgVvyxdc8SFZ7gm69go2KDdt3ag071iBaWPF6cjs=
 github.com/spf13/afero v1.8.2 h1:xehSyVa0YnHWsJ49JFljMpg1HX19V6NDZ1fkm1Xznbo=
 github.com/spf13/afero v1.8.2/go.mod h1:CtAatgMJh6bJEIs48Ay/FOnkljP3WeGUG0MC1RfAqwo=
 github.com/spf13/cast v1.5.0 h1:rj3WzYc11XZaIZMPKmwP96zkFEnnAmV8s6XbB2aY32w=
