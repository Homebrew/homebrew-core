class Aqua < Formula
  desc "Declarative CLI Version manager"
  homepage "https://aquaproj.github.io/"
  url "https://github.com/aquaproj/aqua/archive/refs/tags/v2.55.2.tar.gz"
  sha256 "b6883514349606f0eafa196279a01bf052164d8b82bc0081e2684f06d4823f66"
  license "MIT"
  head "https://github.com/aquaproj/aqua.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "662ec0e034344d47f907043720e233cb2cb970e6aeaa6a4e2fe2b0f034b6a849"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "662ec0e034344d47f907043720e233cb2cb970e6aeaa6a4e2fe2b0f034b6a849"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "662ec0e034344d47f907043720e233cb2cb970e6aeaa6a4e2fe2b0f034b6a849"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf1fa739c59d2515b5e13ccda0599ad048555bd0c54c378106bcab69d0ddf161"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3482a90345df4b6ab8576e00ab46f0832cf0ca8367c60d9d528028c9f455747"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a68b4034169b5329f3a8b9c7644f85315870ebdafc4681aaa0b9b629dff7233b"
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
