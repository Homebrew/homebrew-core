class Kekkai < Formula
  desc "File integrity monitoring tool"
  homepage "https://github.com/catatsuy/kekkai"
  url "https://github.com/catatsuy/kekkai/archive/refs/tags/v0.2.14.tar.gz"
  sha256 "fe678021efecc7444cc62d524352a0a1c5ecab46e017098726b63f7665fa03ea"
  license "MIT"
  head "https://github.com/catatsuy/kekkai.git", branch: "main"

  bottle do
    manifest_sha256 "a38f78d56d467ef07f38c0ad5e869ecbc8d4de35dab5547024773db86fb710ea"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0de79defc7154b088adc138e76d8a21133091819e519e5f56fe2489e93f4315c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0de79defc7154b088adc138e76d8a21133091819e519e5f56fe2489e93f4315c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0de79defc7154b088adc138e76d8a21133091819e519e5f56fe2489e93f4315c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6f2b2e54fe1f2db1306fc6777ef39f7792c269dd664af8f27dc633affdce833e"
    sha256 cellar: :any,                 x86_64_linux:      "3b736ceb1587ccb4113972e6f30938a7bf80a05e839ea4dff538101495da5e6c"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/catatsuy/kekkai/internal/cli.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/kekkai"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kekkai version")

    system bin/"kekkai", "generate", "--output", "kekkai-manifest.json"
    assert_match "files", (testpath/"kekkai-manifest.json").read
  end
end
