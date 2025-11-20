class CloudProviderKind < Formula
  desc "Cloud provider for KIND clusters"
  homepage "https://github.com/kubernetes-sigs/cloud-provider-kind"
  url "https://github.com/kubernetes-sigs/cloud-provider-kind/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "bfeeabdeb12d742608492e56b3ac261d3208ded72f9335b3195695654a00909f"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cloud-provider-kind.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd6809959e5c4db2f5d16a0a3377d298d23831a8aa0889b15d5e43c1cdefdeb3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "501076b26258448230a71be544bf5a3f11cb7c160f69d3c87123b0f46191112e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f662274498463cd4691da354b29effaf4c8f9650c7f767e6801bb362a42e0931"
    sha256 cellar: :any_skip_relocation, sonoma:        "0cc93b9511006780da356d6c60689522cf1b346f4a890f80cd22fd64eaa3b5a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "571409c17bfae88192e6422fefb598b2ccdb3ed7467c3506cfb6e850973a4ce5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32d44aaa54e496caea95f534a143997243d4e96acda85d7fb8f42b7aac59bf3e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"
    status_output = shell_output("#{bin}/cloud-provider-kind 2>&1", 255)
    if OS.mac?
      # Should error out as requires root on Mac
      assert_match "Please run this again with `sudo`", status_output
    elsif OS.linux?
      # Should error out because without docker or podman
      assert_match "can not detect cluster provider", status_output
    end
  end
end
