class Crane < Formula
  desc "Tool for interacting with remote images and registries"
  homepage "https://github.com/google/go-containerregistry"
  url "https://github.com/google/go-containerregistry/archive/refs/tags/v0.20.2.tar.gz"
  sha256 "064e9c47e3dac49acddccb4afe908b9d835725d371ee9a471fd445d134fbbf1d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e0cc6ea093955193954e8b8ea3b56661411e75880b56446414a5fa0f1896bd09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "07d234e90cf176df22f36ff4fbfec94b60e441a9fb88ce756777d6e8d29ac24c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "543bcd7edbed1c3e52c59da7385256ce6bf2664329890b57a507aa154e98fb3f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f9fee3ac2c33bfc5867ef1190567bc5a4a19f0ce157c05d789e818b3364f85f"
    sha256 cellar: :any_skip_relocation, sonoma:         "55f74183ac13afdb3f07f45de9a5cf898171a1e2114311911fc675d94990384b"
    sha256 cellar: :any_skip_relocation, ventura:        "2dcffe3708e0d51ebc5e946487e16219430062ea231066ec6cce1564fe2f6da1"
    sha256 cellar: :any_skip_relocation, monterey:       "95a24c7749edcd103079a24ae7fbcb5216beaba991c2d09f4795fce4095e264e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cf67c250d910642844c86f2e0962f98bcc35c8167a3c1e3848ef264b306db39"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/google/go-containerregistry/cmd/crane/cmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/crane"

    generate_completions_from_executable(bin/"crane", "completion")
  end

  test do
    json_output = shell_output("#{bin}/crane manifest gcr.io/go-containerregistry/crane")
    manifest = JSON.parse(json_output)
    assert_equal manifest["schemaVersion"], 2
  end
end
