class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://github.com/anchore/grype/archive/refs/tags/v0.74.6.tar.gz"
  sha256 "2055c1cef61ac123a36f9d0348ee7b810b099edb84ea1e1a3230580a7eaeb5d9"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ccf2b4b7e520a5af4f6a504bcffcd6ee4ab68ab6a40045db5638cdcf0d1f30c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf1ddad6ef10472e1ef1270838133fa677cdecea449558ecd29ee5c5941b9e13"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da7c06e886443f99fbd7df0c8059724e74bdd370df5c81201be310f5076421cb"
    sha256 cellar: :any_skip_relocation, sonoma:         "0b865e31ebdc1976eb6c0acd2bf45681b36cfc8c3c0bdabc3347b5c7f63bad16"
    sha256 cellar: :any_skip_relocation, ventura:        "1df00140afbeac5e44575c189e5768ff0f3ac8b070543a6a4f56e58dff767c2f"
    sha256 cellar: :any_skip_relocation, monterey:       "6e68e159d8a4e1c8d8b8f8f16d8ec0b4d6958d349afbf1cbc595aef20fda2c91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e68d0f637f0d37d26f34bbc8ec13c3445872d183ea6a2cc619808a054afd8a71"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=brew
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/grype"

    generate_completions_from_executable(bin/"grype", "completion")
  end

  test do
    assert_match "database metadata not found", shell_output("#{bin}/grype db status 2>&1", 1)
    assert_match "Update available", shell_output("#{bin}/grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}/grype version 2>&1")
  end
end
