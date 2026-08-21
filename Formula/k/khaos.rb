class Khaos < Formula
    desc "Kafka traffic simulator for observability and chaos engineering"
    homepage "https://github.com/aleksandarskrbic/khaos"
    url "https://github.com/aleksandarskrbic/khaos/archive/refs/tags/v0.8.0.tar.gz"
    sha256 "3d20d75c1977eb9c490f10cbe09cfcbfdfc673479f499877fd7b872555c0c0c1"
    license "Apache-2.0"
    head "https://github.com/aleksandarskrbic/khaos.git", branch: "main"

    depends_on "go" => :build

    def install
      system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/khaos"
      generate_completions_from_executable(bin/"khaos", "completion")
    end

    test do
      assert_match "Available Scenarios", shell_output("#{bin}/khaos list")
      assert_match version.to_s, shell_output("#{bin}/khaos --version")
    end
  end
