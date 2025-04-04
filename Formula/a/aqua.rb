class Aqua < Formula
  desc "Declarative CLI Version manager"
  homepage "https://aquaproj.github.io/"
  url "https://github.com/aquaproj/aqua/archive/refs/tags/v2.47.0.tar.gz"
  sha256 "50784439c2f1dee4a0f73bda664ea96e056bd9f070d92a4c3979a3ceaacc26e8"
  license "MIT"
  head "https://github.com/aquaproj/aqua.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34018a444b7f30905a4ace2e5d6cbf0864ad81723bca27aeca26836643a41ddd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34018a444b7f30905a4ace2e5d6cbf0864ad81723bca27aeca26836643a41ddd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "34018a444b7f30905a4ace2e5d6cbf0864ad81723bca27aeca26836643a41ddd"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9a85f2a0dce4865dc0da42196bd01bac3b3fe173761032dbb1ed56766974ad1"
    sha256 cellar: :any_skip_relocation, ventura:       "a9a85f2a0dce4865dc0da42196bd01bac3b3fe173761032dbb1ed56766974ad1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb0feec86a294ebea2d2af98924157dc9ec813b054462d828730efe0089ead96"
  end

  depends_on "go" => :build

  # Fix to correct version output
  # PR ref : https://github.com/aquaproj/aqua/pull/3717
  patch do
    url "https://github.com/aquaproj/aqua/commit/a02bc2d7d6d131ac778f4d8a22adc7c50cd3b772.patch?full_index=1"
    sha256 "a0f79a2f036c81f87753640cc8df41f90a8d5c099942ee2beb8efeac03cb687b"
  end

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/aqua"

    generate_completions_from_executable(bin/"aqua", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aqua version")

    system bin/"aqua", "init"
    assert_match "depName=aquaproj/aqua-registry", (testpath/"aqua.yaml").read
  end
end
