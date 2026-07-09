class Clive < Formula
  desc "Automates terminal operations"
  homepage "https://github.com/koki-develop/clive"
  url "https://github.com/koki-develop/clive/archive/refs/tags/v0.12.17.tar.gz"
  sha256 "fda25e28dece565770d192633aee113f8cfc8f24fc974f0a8ecd59a7fe224f3f"
  license "MIT"
  head "https://github.com/koki-develop/clive.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40adb7ec45e6109de0a0029e42184903c38755a66357eec7eb40a7121256b3be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40adb7ec45e6109de0a0029e42184903c38755a66357eec7eb40a7121256b3be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40adb7ec45e6109de0a0029e42184903c38755a66357eec7eb40a7121256b3be"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d0f533017db7893b99ca20abd6173c0e8d0f4a63121955c688d511c8110f4cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92664c1c45f1690ce7ccf89e336e4509d2d10ec04cc7401f9e5012e9030b7c6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "daa51afb0ece345c9695c767927ba439e11e31f1de9ec5026d65737f3652623d"
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
