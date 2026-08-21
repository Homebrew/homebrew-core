class Droast < Formula
  desc "Opinionated Dockerfile linter"
  homepage "https://ewry.net/droast-dockerfile-linter/"
  url "https://github.com/immanuwell/dockerfile-roast/archive/refs/tags/1.6.1.tar.gz"
  sha256 "e542236407d40e5e4ac43c91950836e9829b93c25e3a038ca987d5ac5fa05511"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd6ae02702ca7e5f1fe27284fcbb0f645e56655799d4cabb371229720888a81e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc5019a1a80232f27e0786dff9d5cfe055f4070f00c18f8e466d775e7ff495a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9651cc371706ba44e88d611511bfe908d280c7846cefd30f28c65b8e4cfbdf25"
    sha256 cellar: :any_skip_relocation, sonoma:        "848ad0b4db113d36eb5597280b22df7cea356969e8c91276932ac247d5a009dc"
    sha256 cellar: :any,                 arm64_linux:   "e647c3f4bace04fecfa4895f2bb05f7fa59944e567ff63c6a1c86ed7b6792a86"
    sha256 cellar: :any,                 x86_64_linux:  "40873526eac3b5f36379e2f71418a0be87ae02f3793270b4e9f98d1b68950e8c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"droast", "completion")
  end

  test do
    (testpath/"Dockerfile").write <<~DOCKERFILE
      FROM alpine:3
      ENTRYPOINT ["echo", "hi"]
      ENTRYPOINT ["echo", "bye"]
    DOCKERFILE
    output = shell_output("#{bin}/droast --no-roast --format compact #{testpath}/Dockerfile", 1)
    assert_match "DF039", output
  end
end
