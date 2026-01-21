class Ctlptl < Formula
  desc "Making local Kubernetes clusters fun and easy to set up"
  homepage "https://github.com/tilt-dev/ctlptl"
  url "https://github.com/tilt-dev/ctlptl/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "3873e62a5958d7e4596ee6673ec7890a9df1c1ab9d82c82e6e262798915e484e"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/ctlptl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2db00a1209c73af9306a064fdec47d228607864c37905bec3ab7393dd063675"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "378125fe57abc90a17ef3fe241ebef42e7fa17c2022b10cc3c33b7cbe2d307e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ff67e9a26cb82cd7f2869e46686937d03ce50885f586f5863e1eda3c3933fd2"
    sha256 cellar: :any_skip_relocation, sonoma:        "909c40fae7217e48845fa9625df6fcee26cce215b214650f8c386a62dab8cd1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6046f3a5c9912524696d7f3cd007f2b61c6e3b955785ca0e44d7acb18f99ba36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ccd09303d6544ba705ac0876d0f0b851514af99388f65b297904b75968ccdc0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ctlptl"

    generate_completions_from_executable(bin/"ctlptl", shell_parameter_format: :cobra)
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/ctlptl version")
    assert_empty shell_output("#{bin}/ctlptl get")
    assert_match "not found", shell_output("#{bin}/ctlptl delete cluster nonexistent 2>&1", 1)
  end
end
