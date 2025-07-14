class Kubetail < Formula
  desc "Logging tool for Kubernetes with a real-time web dashboard"
  homepage "https://www.kubetail.com/"
  url "https://github.com/kubetail-org/kubetail/archive/refs/tags/cli/v0.7.1.tar.gz"
  sha256 "30abc5c597ede51d452b759fe1bf9164838ce672a424065cb6734bdff76d3298"
  license "Apache-2.0"
  head "https://github.com/kubetail-org/kubetail.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c338f3c7e5fed09e3db7489f3555c51fb861452a28c512c257b159aa6d9ec4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "617a3aeb4099ef80e057ccedbe8b63c22d3c2ab7d25241f02c894b0a11bbf96e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2858da571ef39c552ee135be646bbe7267b5ef494a0338ad8c14edbe4f73f765"
    sha256 cellar: :any_skip_relocation, sonoma:        "55903cc3751b9f9f6073c2c60df88f93298ed53b6fcb6629aaf757aca0c6ce50"
    sha256 cellar: :any_skip_relocation, ventura:       "26c7dae28f2d15ef246e1bbdee90c87a17efd8efa29072b9f149d96133328efc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27d013b7e7de1424bbd75a0b822889fa66bb0519ce428b70789a4f96d52ab7ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21eb3bc4ced2bbf5d8e21715ac7e0e35b578b0d86127dd2fc8aec157ea4cdbf5"
  end

  depends_on "go" => :build
  depends_on "make" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "bin/kubetail"
    generate_completions_from_executable(bin/"kubetail", "completion")
  end

  test do
    command_output = shell_output("#{bin}/kubetail serve --test")
    assert_match "ok", command_output

    assert_match version.to_s, shell_output("#{bin}/kubetail --version")
  end
end
