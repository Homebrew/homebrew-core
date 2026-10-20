class Kuberlr < Formula
  desc "Simplifies the management of multiple versions of kubectl"
  homepage "https://github.com/flavio/kuberlr"
  url "https://github.com/flavio/kuberlr/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "d25eaca1f083517e4f252246b5657553dfe46746f607fbf8d1c6c224241da6e4"
  license "Apache-2.0"
  head "https://github.com/flavio/kuberlr.git", branch: "main"

  depends_on "go" => :build

  deny_network_access! :test

  def install
    ldflags = %W[
      -X github.com/flavio/kuberlr/pkg/kuberlr.Version=#{version}
      -X github.com/flavio/kuberlr/pkg/kuberlr.BuildDate=#{time.iso8601}
      -X github.com/flavio/kuberlr/pkg/kuberlr.Tag=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/kuberlr"

    generate_completions_from_executable(bin/"kuberlr", "completion")

    (libexec/"bin").install_symlink bin/"kuberlr" => "kubectl"
  end

  def caveats
    <<~EOS
      kuberlr works by intercepting calls to kubectl. A `kubectl` link to
      kuberlr has been installed; to give it priority over any other kubectl
      on your PATH, add this to your shell profile:
        PATH="#{opt_libexec}/bin:$PATH"
    EOS
  end

  test do
    assert_match "kuberlr version: #{version}", shell_output("#{bin}/kuberlr version")

    ENV["HOME"] = testpath
    assert_match "No binaries found.", shell_output("#{bin}/kuberlr bins")

    assert_equal (bin/"kuberlr").realpath, (libexec/"bin/kubectl").realpath
  end
end
