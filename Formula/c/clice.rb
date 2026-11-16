class Clice < Formula
  desc "Next-generation C++ language server for modern C++"
  homepage "https://docs.clice.io/"
  url "https://github.com/clice-io/clice/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "376f3a368020a67e85475f5ec4630ac2e144a9db188c03b07f3c6d8198e4fcf7"
  license "Apache-2.0"

  depends_on "bazel" => :build
  depends_on "node" => :build

  uses_from_macos "python" => :build

  allow_network_access! :build

  def install
    # Using upstream's Bazel build instructions
    cache = buildpath/"thinlto-cache"
    cache.mkpath
    inreplace "bazel/clice.bazelrc", "/var/tmp/xclang-thinlto", cache.to_s

    ENV.remove "PATH", Superenv.shims_path
    system "bazel", "--output_user_root=#{buildpath}/bazel-root", "build",
           "--repo_contents_cache=", "--action_env=PATH=#{ENV["PATH"]}",
           "--jobs=#{ENV.make_jobs}", "//:package"

    system "tar", "-xf", "build/RelWithDebInfo/bin/clice.tar.gz"
    libexec.install "clice/bin", "clice/lib"
    bin.install_symlink libexec/"bin/clice"
  end

  test do
    (testpath/"main.c").write <<~C
      #include <stddef.h>
      size_t answer(void) { return sizeof(int); }
    C
    (testpath/"compile_commands.json").write JSON.generate([{
      directory: testpath.to_s,
      arguments: [which("cc").to_s, "-c", "main.c"],
      file:      "main.c",
    }])

    resource_dir = (libexec/"lib/clang").children.find(&:directory?)
    assert_path_exists resource_dir/"include/stddef.h"
    assert_match "-resource-dir #{resource_dir.realpath}", shell_output("#{bin}/clice command main.c")

    output = shell_output("#{bin}/clice index --jobs 1 2>&1")
    assert_match "Indexed 1 translation unit", output
    refute_match "compiled with errors", output
  end
end
