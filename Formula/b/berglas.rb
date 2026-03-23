class Berglas < Formula
  desc "Tool for managing secrets on Google Cloud"
  homepage "https://github.com/GoogleCloudPlatform/berglas"
  url "https://github.com/GoogleCloudPlatform/berglas/archive/refs/tags/v2.0.10.tar.gz"
  sha256 "36797ff44e547de7307ed12edb7a4c2e4e25302fbf67c843c2989ae2b986eab1"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/berglas.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5edffc0b04809e14dc257028bc2c1ab2b64d363a65df5d69b4255fff02a874e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5edffc0b04809e14dc257028bc2c1ab2b64d363a65df5d69b4255fff02a874e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5edffc0b04809e14dc257028bc2c1ab2b64d363a65df5d69b4255fff02a874e"
    sha256 cellar: :any_skip_relocation, sonoma:        "24162cc07a5f7e9a78ab089792d94bffe786d3d1ae56406e29fe48c986dec8f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77d9b4db64dbab7bd2ff8245e7ffd9226eb3063fd1ab32483f8ce4e70d617ee4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a52c8f50ae26f61411fe2dc136c298724ba99afc3c662a78628c383ea0dd56a2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/GoogleCloudPlatform/berglas/v2/internal/version.name=berglas
      -X github.com/GoogleCloudPlatform/berglas/v2/internal/version.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"berglas", "completion", shells: [:bash, :zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/berglas -v")

    out = shell_output("#{bin}/berglas list -l info homebrewtest 2>&1", 61)
    assert_match "could not find default credentials.", out
  end
end
