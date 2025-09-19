class Observerward < Formula
  desc "Web application and service fingerprint identification tool"
  homepage "https://emo-crab.github.io/observer_ward/"
  url "https://github.com/emo-crab/observer_ward/archive/refs/tags/v2025.9.18.tar.gz"
  sha256 "a2fcbb805c52ffb31b38a433de7aa66e015ef9d746a83223df9d60b792c1208c"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8a9c275ab9ba35cb0296b36442dc36c48186132e5dd076988daba5f3325feacf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2e316cec20279e56392db263268809bca8ca323fe4b292fdb94e7887315504f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab2b9c1bc85d375a2970563e3674158018488afaff2e28468c019aa8af7df4fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd8f343c6678135a07d38b6a63cb9cb020109a6a4cda860946915975a63518b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb91ea7cad8a2a07cd3c8f6defabbba0ed3b3c007305c9a0ab0f3b3b54334a1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "703492aa176008c88997df123d6579e44d0e82b81a34496c44c32768e6ced25c"
  end

  depends_on "rust" => :build

  def install
    rm ".cargo/config.toml" # disable `+crc-static`
    system "cargo", "install", *std_cargo_args(path: "observer_ward")
  end

  test do
    require "utils/linkage"

    system bin/"observer_ward", "-u"
    assert_match "0example", shell_output("#{bin}/observer_ward -t https://www.example.com/")
  end
end
