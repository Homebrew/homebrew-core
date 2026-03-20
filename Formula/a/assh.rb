class Assh < Formula
  desc "Advanced SSH config - Regex, aliases, gateways, includes and dynamic hosts"
  homepage "https://v1.manfred.life/assh/"
  url "https://github.com/moul/assh/archive/refs/tags/v2.17.1.tar.gz"
  sha256 "9571e3424dcfa5d52e32f3f7dd19995e3d1f30c9d80420e77d47681d4a201744"
  license "MIT"
  head "https://github.com/moul/assh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dfda9601a1a38d79acb4283392253abcca6922a651c7f3e37766bded440af19e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84b25532eba743cebccebf5819911f2808e468b81117385537bdff21f095080d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a812ac12e89c0d6ebf286a698dbd12203b42387697b18e1e5ddd504d14cf014f"
    sha256 cellar: :any_skip_relocation, sonoma:        "498ae24af8078005e9c6094f79be928fda04fa153be40640c37ee89db47deeba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "230436b583369233054a88d78be4e51a5c75509e9c50dfb609a89e8de632433e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1bb3a17a7f35cb82a642adb348100d00a69c220576402ad8bb8d500056bab90"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"assh", shell_parameter_format: :cobra)
  end

  test do
    assh_config = testpath/"assh.yml"
    assh_config.write <<~YAML
      hosts:
        hosta:
          Hostname: 127.0.0.1
      asshknownhostfile: /dev/null
    YAML

    output = "hosta assh ping statistics"
    assert_match output, shell_output("#{bin}/assh --config #{assh_config} ping -c 4 hosta 2>&1")
  end
end
