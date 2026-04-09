class Clive < Formula
  desc "Automates terminal operations"
  homepage "https://github.com/koki-develop/clive"
  url "https://github.com/koki-develop/clive/archive/refs/tags/v0.12.16.tar.gz"
  sha256 "a08e5143d657a236edd1d90332b4d8c8e8a1899480b595fd8688678a86d7db84"
  license "MIT"
  head "https://github.com/koki-develop/clive.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a9327759ff50f04774163452e0a60dff60b69f527e6469d41160ff1b035febe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a9327759ff50f04774163452e0a60dff60b69f527e6469d41160ff1b035febe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a9327759ff50f04774163452e0a60dff60b69f527e6469d41160ff1b035febe"
    sha256 cellar: :any_skip_relocation, sonoma:        "13dfb211db8851a2a42ac0f4821157125b4883fab14b108b74cc0bf791dfef73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f659f4937a4a0c6ac175d18849e424e6507f23ae7ea5eb5edebf2ea372adee44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a747c9d5ef60f51f3cc127f41f0bd83efb2785835d0e35c59ecb437c3bf36ba"
  end

  depends_on "go" => :build
  depends_on "ttyd"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/koki-develop/clive/cmd.version=v#{version}")
    generate_completions_from_executable(bin/"clive", shell_parameter_format: :cobra)
  end

  test do
    system bin/"clive", "init"
    assert_path_exists testpath/"clive.yml"

    system bin/"clive", "validate"
    assert_match version.to_s, shell_output("#{bin}/clive --version")
  end
end
