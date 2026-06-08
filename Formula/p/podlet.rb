class Podlet < Formula
  desc "Generate podman quadlet files from a podman command or compose file"
  homepage "https://github.com/containers/podlet"
  url "https://github.com/containers/podlet/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "2dee85888e0f4ad1d8d7f6c7579d00faa69bb8dbcb4708706ef8db92e41f9bef"
  license "MPL-2.0"
  head "https://github.com/containers/podlet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3ab068fe8e02eb0da24e71e05b6ffc37830348c759c160cd2f4d079baa0e38a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72dd5ea24937f10ef025c3e98773cdec5ae7e1a1e81db986362e33c5231c98f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ec0271baaf497877db2959e65cb8eaea3eae0a14436585791b75774d6e416b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "20f132308d23a79c6f23ff66afe99cbe8b8667185cb8108fc88d2ac290e721e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a51787c612d57e02114ce151807102aead624fef6df4f70bccaeb856fd92542b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c68f84265fd23be3bbdb201ec528d2b32f6b390006ae8003ca7f6a8d6469c349"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    expected_output = <<~EOS
      # FileName=hello
      [Container]
      Image=quay.io/podman/hello
    EOS

    assert_equal expected_output, shell_output("#{bin}/podlet podman run quay.io/podman/hello")
  end
end
