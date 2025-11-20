class Aqua < Formula
  desc "Declarative CLI Version manager"
  homepage "https://aquaproj.github.io/"
  url "https://github.com/aquaproj/aqua/archive/refs/tags/v2.55.1.tar.gz"
  sha256 "534ed9cc19f7a38fcd126b34d3a37993ec4b90105fe12e113ce27cc4218a6290"
  license "MIT"
  head "https://github.com/aquaproj/aqua.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e691f48d6e680f37c396407bc585f218ab6a93d7024e01b2fce9ab7f6e2bb3de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e691f48d6e680f37c396407bc585f218ab6a93d7024e01b2fce9ab7f6e2bb3de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e691f48d6e680f37c396407bc585f218ab6a93d7024e01b2fce9ab7f6e2bb3de"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1b1c119106f5988119f0979b1daf6fb69fbac46cdc2f0bee122dadbbbef0dd2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dff2e74bf39baf368435fa6a0ed2380c1347d40bf5915e3d7c7d357c02acdc13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5df0dc645916132d74c1b58f3f60cb97235fc6561f534c83e03a3147e2037738"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/aqua"

    generate_completions_from_executable(bin/"aqua", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aqua --version")

    system bin/"aqua", "init"
    assert_match "depName=aquaproj/aqua-registry", (testpath/"aqua.yaml").read
  end
end
