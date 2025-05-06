class Kubetail < Formula
  desc "Logging tool for Kubernetes with a real-time web dashboard"
  homepage "https://www.kubetail.com/"
  url "https://github.com/kubetail-org/kubetail/archive/refs/tags/cli/v0.5.0.tar.gz"
  sha256 "a045541fa94e3877df581c673227d8dd6c376d341f3148185ef5b6f40f9206a1"
  license "Apache-2.0"
  head "https://github.com/kubetail-org/kubetail.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27d4056e31aa83b6b21feddf6fc8222c153f779e8ee41b6002e81c6b2ba0bddc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "721ec9d5dfb8e23a9bbb2556a0c42b7680db44799dadc40bbf22b0c1404204f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f05cb6c0d432850f83e39a76366bf17a8c964671bec65b8b649007f7d4931488"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c8a1e6f653028556b1e3eebcc5df4e5aa8a524b09c6ea900e8db25056b3f33c"
    sha256 cellar: :any_skip_relocation, ventura:       "aeb474959fb908f01ee4ddf85b5644ce9712f4c4119640f00368b8836061bdd7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01adbb2091b5b7fc40148b12f27e16b8f3e26a3c9bc25e565fba7e992c495e94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e081c4687eb664fbb2592b2ff7169d7bb32270544085f154a75063648d68334e"
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
