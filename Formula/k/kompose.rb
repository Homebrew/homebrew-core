class Kompose < Formula
  desc "Tool to move from `docker-compose` to Kubernetes"
  homepage "https://kompose.io/"
  url "https://github.com/kubernetes/kompose/archive/v1.31.2.tar.gz"
  sha256 "6c3bb81f9845941d949fd4d950967639fdc502508fa5fe5b030a4daee6776f8d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6cb412663d3718f63956dd285b461e8f37fb16f1dea2a587982d46120d0828c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "77a630e1ce1bcc758309279e8466527d10440d720f015d7b5721b48c9faff305"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44e27bc9e7f91befe3fe6e34fe665b9552cfeb5009acfa86bc11c18d956a3f41"
    sha256 cellar: :any_skip_relocation, sonoma:         "64f97d83782f705075e65958e435867145a18837af6f6e5a9716d465529e2f3a"
    sha256 cellar: :any_skip_relocation, ventura:        "b6cd7ca3ecef63cedf6495c87b231c5dac25071e5b2f750709580f9bccaa9777"
    sha256 cellar: :any_skip_relocation, monterey:       "cc0e75c4069050f4806b233851c68d8ab4702a8ed908565349aca335447497e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99550035b8938199c758e0097ffc8ca525a7af19d48080d50955153c6587a0e8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"kompose", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kompose version")
  end
end
