class DjlBench < Formula
  desc "Command-line tool that helps to benchmark the model on different platforms"
  homepage "https://github.com/deepjavalibrary/djl/tree/master/extensions/benchmark"
  url "https://publish.djl.ai/djl-bench/0.12.0/benchmark-0.12.0.tar"
  sha256 "778df005951c546c4e8e4e22dd62e1bc64b413334e0951ffbd8d06be5cc6ce19"
  license "Apache-2.0"

  depends_on "openjdk"

  def install
    rm_rf Dir["bin/*.bat"]
    prefix.install_metafiles
    mv "bin/benchmark", "bin/djl-bench"
    libexec.install Dir["*"]
    djl_env = { APP_HOME: "${APP_HOME:-#{var}}" }
    djl_env.merge!(Language::Java.overridable_java_home_env)
    (bin/"djl-bench").write_env_script "#{libexec}/bin/djl-bench", djl_env
  end

  service do
    run [opt_bin/"djl-bench", "run"]
    keep_alive true
  end

  test do
    djlbenchcommand = "djl-bench -c 2 -s 1,3,224,224 -a ai.djl.mxnet:resnet -r" \
                      "'{'layers':'50','flavor':'v2','dataset':'imagenet'}'"
    output = shell_output("#{bin}/#{djlbenchcommand}")
    sleep 30
    assert_includes output, "[INFO ] - Running Benchmark on:"
  end
end
