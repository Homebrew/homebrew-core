class Gnmic < Formula
  desc "GNMI CLI client and collector"
  homepage "https://gnmic.openconfig.net"
  url "https://github.com/openconfig/gnmic/archive/refs/tags/v0.46.0.tar.gz"
  sha256 "325ba31b59fe255f1265dc01ec721c17bef3479ed4fcd12bbc4ddf525ba1e5a0"
  license "Apache-2.0"
  head "https://github.com/openconfig/gnmic.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7ecae92177e2789f5f19f07c86ce7e1e490c50fb09c374c1ee5443caacffca1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ec89a5566ef72f8ed1bb69b3e961231c85eee2dabc7f522848d8b76b7bf2c8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2936e894739703897762b81f9436079a74b68f621a370d0876ad40a9d908185a"
    sha256 cellar: :any_skip_relocation, sonoma:        "25bfa5df4096527bc3a4642532c48c33fe01ba31f7ca3a804e1268774b1ccfea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d43e3674e3e92aca5554c7fc5db1ee590f2e796815fc8f433300df4812ed3178"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f818492a3ef79c7f2348772abbca0c28c6b843ebfe289c18e5b3b7a12cb87c45"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/openconfig/gnmic/pkg/version.Version=#{version}
      -X github.com/openconfig/gnmic/pkg/version.Commit=#{tap.user}
      -X github.com/openconfig/gnmic/pkg/version.Date=#{time.iso8601}
      -X github.com/openconfig/gnmic/pkg/version.GitURL=https://github.com/openconfig/gnmic
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"gnmic", "completion")
  end

  test do
    connection_output = shell_output("#{bin}/gnmic -u gnmi -p dummy --skip-verify \
                                     --timeout 1s -a 127.0.0.1:0 capabilities 2>&1", 1)
    assert_match "target \"127.0.0.1:0\", capabilities request failed", connection_output

    assert_match version.to_s, shell_output("#{bin}/gnmic version")
  end
end
