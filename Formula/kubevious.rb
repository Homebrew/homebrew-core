require "language/node"

class Kubevious < Formula
  desc "Detects and prevents Kubernetes misconfigurations and violations"
  homepage "https://github.com/kubevious/cli"
  url "https://registry.npmjs.org/kubevious/-/kubevious-1.0.52.tgz"
  sha256 "4132ec8ae379a65b0532bf79d92900bf58428cdd10c51df1092a79334b57e3bd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7cde5912f419c200882705faa47faec48060bca49e86d65d724d2f3824c8337c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc28caaffda3834f9a9097bf6d337a67d6191be931b64bd5d1c90782c5695df2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4d3650748fb5505e2c0ced4bd70b50b15e2fb8c02edd867ec9090067a4e33e71"
    sha256 cellar: :any_skip_relocation, ventura:        "69b9522b00f2a9a50e240b6fad5ab930e7e86ac17b471fbacb1fa02fbc4e974d"
    sha256 cellar: :any_skip_relocation, monterey:       "f051c0b9a18c93adfc51658ac71bb608e4b0a0299b18a69843ac8a37a2fb9c43"
    sha256 cellar: :any_skip_relocation, big_sur:        "5c80c97e7a366dad8b1447ad5a6063a6cddf6e57eece4b0d2ad610594e33b422"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "984b531593b6d8842cb75a34c1ceafd0ba211f85d7c9bcdaec4e4faeb8eba840"
  end

  # Match deprecation date of `node@14`.
  # TODO: Remove if migrated to `node@18` or `node`. Update date if migrated to `node@16`.
  # Issue ref: https://github.com/kubevious/cli/issues/8
  deprecate! date: "2023-04-30", because: "uses deprecated `node@14`"

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
