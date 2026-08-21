class Kubetail < Formula
  desc "Logging tool for Kubernetes with a real-time web dashboard"
  homepage "https://www.kubetail.com/"
  url "https://github.com/kubetail-org/kubetail/archive/refs/tags/cli/v0.18.0.tar.gz"
  sha256 "17517edc4b4ad2f88fb22c679c864f043c07b034151de79c8d594acfc0af0281"
  license "Apache-2.0"
  head "https://github.com/kubetail-org/kubetail.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "006de39f96d8dfbe12dc2527c5934d8334c8eaf4d553882cba1583f4d9eddea8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92a5bf30fea6812d507c5b75f4ae0033adc25ea679e36895415e30211af9e61f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b90c43693dd16dd41c16e32d439ba33ce49d4c53b3fef9c48550bd4dc27fbd2"
    sha256 cellar: :any_skip_relocation, sonoma:        "f0b5139612585c2f78592607d7c5cd93ced6eee86901172d98b574338c85f004"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98ac235bc6a43dfe619937e902713034d2536f9b52cacb9c42665ba188a838a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb1b8f650ae2f257b4e26e3a8127e85b0857553ad74e3132b27b624eaad2faf5"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "bin/kubetail"
    generate_completions_from_executable(bin/"kubetail", shell_parameter_format: :cobra)
  end

  test do
    command_output = shell_output("#{bin}/kubetail serve --test")
    assert_match "ok", command_output

    assert_match version.to_s, shell_output("#{bin}/kubetail --version")
  end
end
