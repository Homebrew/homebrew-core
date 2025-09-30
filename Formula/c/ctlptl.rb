class Ctlptl < Formula
  desc "Making local Kubernetes clusters fun and easy to set up"
  homepage "https://github.com/tilt-dev/ctlptl"
  url "https://github.com/tilt-dev/ctlptl/archive/refs/tags/v0.8.43.tar.gz"
  sha256 "4169e420f72754601c1c2748d5caf32297bf54d76f6e13fe9e6fe1eccadba2e1"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/ctlptl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "563cd1573b10e263363451ed4eab6b7f73dfc82a8cb6a91081cbdc48caf1ce69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84d55c589d2404f0d9bc9ef50aedcdd07e6edbdf0144ea4ec56e22eeacfc7c21"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab6561e0570beca2772f5dbb23289d8f44152314498af4df7c269af9011f52c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0e645578d47b9624166d3135bea522db384ccaa1d2dc270635e476e30a2b6a9e"
    sha256 cellar: :any_skip_relocation, sonoma:        "60dcca8a2ebcee6a48d441fe768377f7bad5d6c17d46eae917f5b9e4106b64d0"
    sha256 cellar: :any_skip_relocation, ventura:       "46d19cf3ffa4b668f93eef17a2f4cf24179d08fc0a05d85fa3c9b2e907fbb095"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf1739b5baaf62399a6b4232011e76de80757143e720c14f9762be303a8c73a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "adf5696d68c18d41745364a3336dc0e5ee89ffc3857c093252d9252d2bb070c1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ctlptl"

    generate_completions_from_executable(bin/"ctlptl", "completion")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/ctlptl version")
    assert_empty shell_output("#{bin}/ctlptl get")
    assert_match "not found", shell_output("#{bin}/ctlptl delete cluster nonexistent 2>&1", 1)
  end
end
