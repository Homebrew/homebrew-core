class Melody < Formula
  desc "Language that compiles to regular expressions"
  homepage "https://yoav-lavi.github.io/melody/book"
  url "https://github.com/yoav-lavi/melody/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "b0dd1b0ecc1af97f09f98a9a741e0dddbf92380c9980140140ff1b4262b9a44a"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f63d6fddea834cd2fd42b11576a634d9b9b22b43029483b522bec09ee4d672c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02ae5a9796e29ff3f0f88a96e957b5c2495a12f27d513eef8ffbf07f07cca8c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d329bc93d86774235dcd465aab7713a214809943998f6b13f4410a72ed44f427"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f6f38b37a164b96b64c1dfbf510ce9c3bfdf714aa78ed019f21ec1f1fae8e6a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ff223f27cb843cbfb6742debd3f37a903ef15e837c58ba6983b7028b151cfb6"
    sha256 cellar: :any_skip_relocation, ventura:       "fc4c23ef29bb5907b1f9888ce9e5d676f30c95d2d5b85392c8ed65317d38a6d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aee430215f65ed5d664571ecdbed0e733a1eabb9316d1d94b5c168333c008ffa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "486bf0de59a35bd2fcad51c0f00156f8eeeba5db3e27b246a5d79105f195a20f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/melody_cli")

    generate_completions_from_executable(bin/"melody", "--generate-completions")
  end

  test do
    mdy = "regex.mdy"
    File.write mdy, '"#"; some of <word>;'
    assert_match "#\\w+", shell_output("#{bin}/melody --no-color #{mdy}")
  end
end
