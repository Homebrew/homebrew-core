require "language/node"

class Kubevious < Formula
  desc "Detects and prevents Kubernetes misconfigurations and violations"
  homepage "https://github.com/kubevious/cli"
  url "https://registry.npmjs.org/kubevious/-/kubevious-1.0.48.tgz"
  sha256 "0be557d44620efb88be216fb5eb65ee15de1cc116026b355341869cccdcc609f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec66659af386cf56d9341bd2866fd9655ed11613893596e1429a76d790b2bbd0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "271f6824ceadfdc4a5d1806debfe7a6ad075b21d5458dd09a7c2f6e0b2a80bf9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3a581cea9751709bc63151f1395d29d1f50333835d6f9a4dee00c742bd58e1ae"
    sha256 cellar: :any_skip_relocation, ventura:        "53cc4d237364389f253b8f38674fb1718b764a7b27c27ccd902c931167833567"
    sha256 cellar: :any_skip_relocation, monterey:       "7037f11b41dc7c48c6f18d070c5e6545da153c2cf1060b49e174f530084775cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "9a547e2a3ccade9883f32790cdc1ab686b7fd0bac2a5200f953f2c5f373e071c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fba58bae4b6d4096ed0538dbec701c2fc8e99896cbc914f136a56266c71785b"
  end

  # upstream issue to track node@18 support
  # https://github.com/kubevious/cli/issues/8
  depends_on "node@14"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin/"kubevious").write_env_script libexec/"bin/kubevious", PATH: "#{Formula["node@14"].opt_bin}:$PATH"
  end

  test do
    assert_match version.to_s,
      shell_output("#{bin}/kubevious --version")

    (testpath/"deployment.yml").write <<~EOF
      apiVersion: apps/v1
      kind: Deployment
      metadata:
        name: nginx
      spec:
        selector:
          matchLabels:
            app: nginx
        replicas: 1
        template:
          metadata:
            labels:
              app: nginx
          spec:
            containers:
            - name: nginx
              image: nginx:1.14.2
              ports:
              - containerPort: 80
    EOF

    assert_match "Lint Succeeded",
      shell_output("#{bin}/kubevious lint #{testpath}/deployment.yml")

    (testpath/"bad-deployment.yml").write <<~EOF
      apiVersion: apps/v1
      kind: BadDeployment
      metadata:
        name: nginx
      spec:
        selector:
          matchLabels:
            app: nginx
        replicas: 1
        template:
          metadata:
            labels:
              app: nginx
          spec:
            containers:
            - name: nginx
              image: nginx:1.14.2
              ports:
              - containerPort: 80
    EOF

    assert_match "Lint Failed",
      shell_output("#{bin}/kubevious lint #{testpath}/bad-deployment.yml", 100)

    assert_match "Guard Succeeded",
      shell_output("#{bin}/kubevious guard #{testpath}/deployment.yml")

    assert_match "Guard Failed",
      shell_output("#{bin}/kubevious guard #{testpath}/bad-deployment.yml", 100)

    (testpath/"service.yml").write <<~EOF
      apiVersion: v1
      kind: Service
      metadata:
        labels:
          app: nginx
        name: nginx
      spec:
        type: ClusterIP
        ports:
        - name: http
          port: 80
          targetPort: 8080
        selector:
          app: nginx
    EOF

    assert_match "Guard Failed",
      shell_output("#{bin}/kubevious guard #{testpath}/service.yml", 100)

    assert_match "Guard Succeeded",
      shell_output("#{bin}/kubevious guard #{testpath}/service.yml #{testpath}/deployment.yml")
  end
end
