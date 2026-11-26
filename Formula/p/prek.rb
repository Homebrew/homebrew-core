class Prek < Formula
  desc "Fast Git hook manager written in Rust, drop-in alternative to pre-commit"
  homepage "https://prek.j178.dev/"
  url "https://github.com/j178/prek/archive/refs/tags/v0.5.12.tar.gz"
  sha256 "679d6708c56991e41943395afd4c5b536beac7fda7b8bb648e238136a19b4af4"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "main"

  bottle do
    manifest_sha256 "fe4782eb1fc27af7f55c6cd291ab303bd27202cf3a996d7d564f5db18c2d5823"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8106c2f243a8cf8646e676f1de75ec32b59df86bc31bcecf45b452073c11edcb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a31255b9c815d7f24652ad580683b638aca2357a2e74e9c36ba54dc29d72519b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ca63d53f9274da7980960be22792fc502e219f099a4f0d9d219a6e503af00bcc"
    sha256 cellar: :any,                 arm64_linux:       "bc06efd7780f6d9b8f8f7f141207d082163e6510194673ed8f628f5a39ecd925"
    sha256 cellar: :any,                 x86_64_linux:      "22fd554f58df10559740f21be8120ef36416426eea080d90ea509baa24c19c38"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["PREK_COMMIT_HASH"] = ENV["PREK_COMMIT_SHORT_HASH"] = tap.user
    ENV["PREK_COMMIT_DATE"] = time.strftime("%F")
    system "cargo", "install", *std_cargo_args(path: "crates/prek")
    generate_completions_from_executable(bin/"prek", shell_parameter_format: :clap)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prek --version")

    output = shell_output("#{bin}/prek sample-config")
    assert_match "See https://prek.j178.dev for more information", output
  end
end
