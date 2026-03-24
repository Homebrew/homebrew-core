class HfMount < Formula
  desc "Mount Hugging Face Buckets and repos as local filesystems"
  homepage "https://github.com/huggingface/hf-mount"
  url "https://github.com/huggingface/hf-mount/archive/refs/tags/v0.0.1.tar.gz"
  sha256 "85197faeb1ceb6a92f59723df4ae6d395bbf7332c3d7de6d75467f895ab9efe5"
  license "Apache-2.0"
  head "https://github.com/huggingface/hf-mount.git", branch: "main"

  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "libfuse"
  end

  def install
    # Ensure openssl-sys finds the Homebrew OpenSSL
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    if OS.mac?
      system "cargo", "install", *std_cargo_args(path: "."),
             "--no-default-features", "--features", "nfs",
             "--bin", "hf-mount-nfs"
      system "cargo", "install", *std_cargo_args(path: "."),
             "--no-default-features",
             "--bin", "hf-mount"
    else
      %w[hf-mount hf-mount-nfs hf-mount-fuse].each do |bin_name|
        system "cargo", "install", *std_cargo_args(path: "."),
               "--no-default-features", "--features", "fuse,nfs",
               "--bin", bin_name
      end
    end
  end

  test do
    assert_match "Mount Hugging Face", shell_output("#{bin}/hf-mount --help")
    assert_match "Mount a HuggingFace", shell_output("#{bin}/hf-mount-nfs --help")
  end
end
