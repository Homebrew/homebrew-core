class Age < Formula
  desc "Simple, modern, secure file encryption"
  homepage "https://github.com/FiloSottile/age"
  url "https://github.com/FiloSottile/age/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "b07c28c6c4bdafa272073a310b75bc22c49da8904585a89c30e5ca4233e63843"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/FiloSottile/age.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ab6acf805fc7c3bd78da358bd3e4b3d4df3cabf6d070e5cc86745643012a4ee0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "48bbd797cd00ab11ec496717f51205ba07f4f7fdc7c8a939c5f4b7b6a11d5287"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "48bbd797cd00ab11ec496717f51205ba07f4f7fdc7c8a939c5f4b7b6a11d5287"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "48bbd797cd00ab11ec496717f51205ba07f4f7fdc7c8a939c5f4b7b6a11d5287"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "09fbfab1b5c6a27c3c44a4436c50436ca1dfe261ecd9a396c5fe840c05f72d22"
    sha256 cellar: :any,                 x86_64_linux:      "5f08c602724d0d9ad66f633301d209ee5ed81c160addd46779f08a0b83442ef1"
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
