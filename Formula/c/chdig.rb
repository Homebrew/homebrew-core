class Chdig < Formula
  desc "Dig into ClickHouse with TUI interface"
  homepage "https://github.com/azat/chdig"
  url "https://github.com/azat/chdig/archive/refs/tags/v26.2.3.tar.gz"
  sha256 "5e05de1cee0db50bbb709887ddf04625029756963edb5e2497e7ef86d03b3e7d"
  license "MIT"
  head "https://github.com/azat/chdig.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "82b1f8af833047a8f9a11173fbcc6054c9c4d17d75e432da6bde14064ad51063"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca993c7430687cea8b522233a53ab3ed86405a1f10a53fdcfa002d58ee98a089"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "425b2cd1cd9f30fe03ecf9ce1494e9e625dba1a5d13b7391a016f7dc4bdccf21"
    sha256 cellar: :any_skip_relocation, sonoma:        "1fca71ddde544243c3858e3c5a7cdafa5c17fa6376dd33da4d70f5b30ea64e15"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "807cc8744cd3ce84156d3c5a716d3e98a1faab59c8535b4318249faff64eb89a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25b9891422340d3d4aa85d9ed8b7d91263a4aa2c45cbe8a8392b12b5d52326b4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"chdig", "--completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chdig --version")

    output = shell_output("#{bin}/chdig --url 255.255.255.255 dictionaries 2>&1", 1)
    assert_match "Error: Cannot connect to ClickHouse", output
  end
end
