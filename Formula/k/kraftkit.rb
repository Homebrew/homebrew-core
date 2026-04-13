class Kraftkit < Formula
  desc "Build and use highly customized and ultra-lightweight unikernel VMs"
  homepage "https://unikraft.org/docs/cli"
  url "https://github.com/unikraft/kraftkit/archive/refs/tags/v0.12.7.tar.gz"
  sha256 "5088ae9faf64b655cae441943089f5248e0f072fbeca14f9db65d3c0d6280dc2"
  license "BSD-3-Clause"
  head "https://github.com/unikraft/kraftkit.git", branch: "staging"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea02698e443b881d59789ebf38cef3271de8c75e9784217259cec4e26b4bda5f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5373c9df613c82dd4cd2a1811330a9e66e826f1ae327c909ded6d38e284b348b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c10a568db91927be2411cd9eff6c5b288cc89ad2c5f303c21c4291b34810e0e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb3b5c8f5e07f1a1e164b8fc225c9c24421275ca3e74905667a5cad676447927"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8a117db143d2211c35468cb78374d224021274675639b43bc0298167b371da4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7193330cf4477d6ffa8770a5a3b8e0019fa1580e9397ee997ffe591ac8e939e"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "gpgme"

  on_linux do
    depends_on "btrfs-progs"
  end

  def install
    ENV["CGO_ENABLED"] = "1"

    ldflags = %W[
      -s -w
      -X kraftkit.sh/internal/version.version=#{version}
      -X kraftkit.sh/internal/version.commit=#{tap.user}
      -X kraftkit.sh/internal/version.buildTime=#{time.iso8601}
    ]
    # Upstream suggested workaround for undefined: securejoin functions
    # Issue ref: https://github.com/unikraft/kraftkit/issues/2581
    tags = %w[
      containers_image_storage_stub containers_image_openpgp netgo osusergo
    ]
    system "go", "build", *std_go_args(ldflags:, tags:, output: bin/"kraft"), "./cmd/kraft"

    generate_completions_from_executable(bin/"kraft", shell_parameter_format: :cobra)
  end

  test do
    expected = if OS.mac?
      "could not determine hypervisor and system mode"
    else
      "finding unikraft.org/helloworld:latest"
    end
    assert_match expected, shell_output("#{bin}/kraft run unikraft.org/helloworld:latest 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/kraft version")
  end
end
