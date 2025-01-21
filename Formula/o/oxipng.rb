class Oxipng < Formula
  desc "Multithreaded PNG optimizer written in Rust"
  homepage "https://github.com/shssoichiro/oxipng"
  url "https://github.com/shssoichiro/oxipng/archive/refs/tags/v9.1.3.tar.gz"
  sha256 "5f34bc3a9eba661a686106261720061b1136301ccd67cc653c9c70d71fa33c09"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da7a006b93d7ee3fe9f667cf1a11a62d8cd79b8f705947c6ffaa5fa42074fec2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b77742c78b5e0e7c3eac52db69bd1f791c7662afccaf910bbd12314f73a89bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6abc255325194b6d36c4c788f44af641f1a208f8d2a5d9ecb8093c10e902e0b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "4dd9ae7f31cf980b3fcef1dd36b5e8e0beaa5c0cbc0ba22641cbe7322fec29c2"
    sha256 cellar: :any_skip_relocation, ventura:       "107479be718136c8c684d9e22abcda1a3f2aad75f9444150cdd98264000cc71b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca221ba914561373dd85ae276ac981f361414ba12eff445739ee30ea327c8b15"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    system "cargo", "run",
           "--manifest-path", "xtask/Cargo.toml",
           "--jobs", ENV.make_jobs.to_s,
           "--locked", "--", "mangen"

    man1.install "target/xtask/mangen/manpages/oxipng.1"
  end

  test do
    system bin/"oxipng", "--pretend", test_fixtures("test.png")
  end
end
