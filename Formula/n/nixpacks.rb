class Nixpacks < Formula
  desc "App source + Nix packages + Docker = Image"
  homepage "https://nixpacks.com/docs/getting-started"
  url "https://github.com/railwayapp/nixpacks/archive/refs/tags/v1.39.0.tar.gz"
  sha256 "ec65a45ddf5a9c33797c1efb73bbcf161c66083ce13c18439d2fb32d50462c21"
  license "MIT"
  head "https://github.com/railwayapp/nixpacks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6812145f5c4012be3d49b54eed485a0cd6648ffd432de1817a2264d3a809239e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68ed68ee3d7cde690d946a09ddb156344ea161a52eacde1370fcbb81694fbee3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ea8e4fdf659c3628a45b69ebcfca3aff29c0477f5b2420dde27602d906a9987a"
    sha256 cellar: :any_skip_relocation, sonoma:        "0aadd297cb4308f8abff20d7a580deeeafe75fb5ba9734076882ab16769326ca"
    sha256 cellar: :any_skip_relocation, ventura:       "8eef015d3c8c721e6a57a009fb52304c7412aa5d6dec47d5854a9c568687b2d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8fa13df53ce48b6e2ede328ab20d3e571676f967ac60d02a60b1bd2f5e3f38ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54332642d6a027f9d51fbc6c0c97f5b6a9fb6ca4113148abb9aaf7c9be87b68c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/nixpacks build #{testpath} --name test", 1)
    assert_match "Nixpacks was unable to generate a build plan for this app", output

    assert_equal "nixpacks #{version}", shell_output("#{bin}/nixpacks -V").chomp
  end
end
