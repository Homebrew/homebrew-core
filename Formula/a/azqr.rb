class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https://azure.github.io/azqr/"
  # pull from git tag to get submodules
  url "https://github.com/Azure/azqr.git",
      tag:      "v.4.0.0",
      revision: "ed6b95888a221c576b53ec39aeb441242112ef4d"
  license "MIT"
  head "https://github.com/Azure/azqr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ba7bb2d9924980fdca0bd316e781bcb7dfef540f432a19746f064058e865624"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ba7bb2d9924980fdca0bd316e781bcb7dfef540f432a19746f064058e865624"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ba7bb2d9924980fdca0bd316e781bcb7dfef540f432a19746f064058e865624"
    sha256 cellar: :any_skip_relocation, sonoma:        "42ff44dd1a24cb27ae71b79c01df268e88f6d77567b040f41825477385cbd2af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4d45e908ddfb5bf5fb715841939c3d55b63e126f14bb849c126dac09b427bb9"
    sha256 cellar: :any,                 x86_64_linux:  "2596599e80e0954a97ff6cb57318f8ff75fc9e76c8215326b14c0eb1357af879"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-X github.com/Azure/azqr/cmd/azqr/commands.version=#{version}]
    system "go", "build", *std_go_args(ldflags:), "./cmd/azqr"

    generate_completions_from_executable(bin/"azqr", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azqr -v")
    output = shell_output("#{bin}/azqr scan --filters notexists.yaml 2>&1", 1)
    assert_includes output, "failed reading data from file"
    output = shell_output("#{bin}/azqr scan 2>&1", 1)
    assert_includes output, "Failed to list subscriptions"
  end
end
