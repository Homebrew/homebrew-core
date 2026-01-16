class Cloudfox < Formula
  desc "Automating situational awareness for cloud penetration tests"
  homepage "https://github.com/BishopFox/cloudfox"
  url "https://github.com/BishopFox/cloudfox/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "25cb07af8dc52a546a363072a32d6047125a49bf437bc1a361b2a16eccf8bce1"
  license "MIT"
  head "https://github.com/BishopFox/cloudfox.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5367d9ebb891aeb292c5a614e354ef1efe5452afd5af672ab8f8849d828f2b0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5367d9ebb891aeb292c5a614e354ef1efe5452afd5af672ab8f8849d828f2b0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5367d9ebb891aeb292c5a614e354ef1efe5452afd5af672ab8f8849d828f2b0a"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa57bb5237d757dfbd4a4af0868da333aa188f0ee944bbb4bd615069eeb5e8c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c75721c2521560b16399455a12f42d603239024c4173790219ee2772ce16a1fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d8756bb7ddeac31e9f0a2246208bc42518205bcd768c971eb523cdef5dfa866"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"cloudfox", shell_parameter_format: :cobra)
  end

  test do
    ENV["AWS_ACCESS_KEY_ID"] = "test"
    ENV["AWS_SECRET_ACCESS_KEY"] = "test"

    output = shell_output("#{bin}/cloudfox aws principals 2>&1")
    assert_match "Could not get caller's identity", output

    assert_match version.to_s, shell_output("#{bin}/cloudfox --version")
  end
end
