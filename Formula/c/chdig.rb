class Chdig < Formula
  desc "Dig into ClickHouse with TUI interface"
  homepage "https://github.com/azat/chdig"
  url "https://github.com/azat/chdig/archive/refs/tags/v25.8.1.tar.gz"
  sha256 "b6dc78c3f5dd546d47e12de27e60a0d0b3bf5d9a5b6abc6430762bb16f173dcb"
  license "MIT"
  head "https://github.com/azat/chdig.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3dc4c2378f46d16477f6f61933bba9a5944dd37aa22c3b1a82fe5aca68abc800"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b91583a892f7639ca2a20a7e0b26e220532fc3be0d3e185b86e7aae7bacd2522"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af55270f0106dbc899d84aed26b5c81ae17f32a8ed1572fa54f947fdb38663e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2e41991c6e192526a75fe333059ce9c7c4893abce65fc4054a8ed067d22f5581"
    sha256 cellar: :any_skip_relocation, sonoma:        "f366f90df014ea56d40357ae836564cd9cec61bab9710f37af9f8efd076fb449"
    sha256 cellar: :any_skip_relocation, ventura:       "caf4a18e50cedb8d9ed8fb668edde89c8545e93eedc7d4e289fd830aba087a42"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1a74784642f4adfb549bf605b1e4749305577ea8fd7e903db4ec1e78862db72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "567730222e9a27df6465626ce5743660f3ef617e7887c989ac5948c72ce6174c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"chdig", "--completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chdig --version")

    # failed with Linux CI, `No such device or address (os error 6)`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    output = shell_output("#{bin}/chdig --url 255.255.255.255 dictionaries 2>&1", 1)
    assert_match "Error: Cannot connect to ClickHouse", output
  end
end
