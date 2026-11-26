class Age < Formula
  desc "Simple, modern, secure file encryption"
  homepage "https://github.com/FiloSottile/age"
  url "https://github.com/FiloSottile/age/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "b07c28c6c4bdafa272073a310b75bc22c49da8904585a89c30e5ca4233e63843"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/FiloSottile/age.git", branch: "main"

  bottle do
    rebuild 1
    manifest_sha256 "26b26360b892e7e5ac7a1373a6b371a804a8f954de862e8f1064d4f875499ea0"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "be936f9451d194d8c96df7b12e6ab75b60919d794b934cc2b58e8be7c3459f9c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "be936f9451d194d8c96df7b12e6ab75b60919d794b934cc2b58e8be7c3459f9c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "be936f9451d194d8c96df7b12e6ab75b60919d794b934cc2b58e8be7c3459f9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d81433310344d11fbb32059238f6600153601ffe6495b43ac32203b6fef4b5eb"
    sha256 cellar: :any,                 x86_64_linux:      "9ed9a65cc817d529b9d5e53044d77d133735f4ecd5e0a54f2b5552830b38f82d"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.Version=v#{version}"
    # `extra` contains the age-plugin-{pq,tag,tagpq} compatibility plugins,
    # which add the age v1.3 recipient types to tools linking an older or
    # plugin-only age library (e.g. sops).
    %w[cmd extra].each do |dir|
      (buildpath/dir).each_child(false) do |cmd|
        system "go", "build", *std_go_args(ldflags:, output: bin/cmd), "./#{dir}/#{cmd}"
      end
    end

    man1.install Dir["doc/*.1"]
  end

  test do
    # Ensure age finds this keg's age-plugin-pq even if the keg is unlinked.
    ENV.prepend_path "PATH", bin

    system bin/"age-keygen", "-o", "key.txt"
    pipe_output("#{bin}/age -e -i key.txt -o test.age", "test", 0)
    assert_equal "test", shell_output("#{bin}/age -d -i key.txt test.age")

    # Round-trip through the plugin protocol using age-plugin-pq.
    system bin/"age-keygen", "-pq", "-o", "pq.txt"
    system bin/"age-plugin-pq", "-identity", "-o", "pq-plugin.txt", "pq.txt"
    assert_match "AGE-PLUGIN-PQ-1", (testpath/"pq-plugin.txt").read
    pipe_output("#{bin}/age -e -i pq-plugin.txt -o pq.age", "test pq", 0)
    assert_equal "test pq", shell_output("#{bin}/age -d -i pq-plugin.txt pq.age")

    %w[age-inspect age-plugin-batchpass age-plugin-tag age-plugin-tagpq].each do |cmd|
      assert_equal "v#{version}", shell_output("#{bin}/#{cmd} -version").strip
    end
  end
end
